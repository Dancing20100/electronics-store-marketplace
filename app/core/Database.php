<?php
/**
 * Database Abstraction Layer
 * 
 * Handles all database connections, queries, and transactions using PDO.
 * Provides prepared statement support to prevent SQL injection.
 * 
 * @package ElectronicsStore
 * @subpackage Core
 * @version 1.0.0
 */

namespace App\Core;

use PDO;
use PDOException;

class Database
{
    /**
     * PDO connection instance
     * @var PDO|null
     */
    private static ?PDO $connection = null;

    /**
     * Query log for debugging
     * @var array
     */
    private static array $queryLog = [];

    /**
     * Transaction stack
     * @var array
     */
    private static array $transactionStack = [];

    /**
     * Get database connection
     * 
     * Creates a new PDO connection if one doesn't exist.
     * Implements singleton pattern for connection pooling.
     *
     * @return PDO
     * @throws PDOException
     */
    public static function connection(): PDO
    {
        if (self::$connection === null) {
            self::connect();
        }

        return self::$connection;
    }

    /**
     * Connect to database
     *
     * @return void
     * @throws PDOException
     */
    private static function connect(): void
    {
        $dsn = sprintf(
            'mysql:host=%s;port=%d;dbname=%s;charset=%s',
            DB_HOST,
            DB_PORT,
            DB_NAME,
            DB_CHARSET
        );

        $options = [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
            PDO::ATTR_PERSISTENT => false,
            PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES " . DB_CHARSET,
        ];

        try {
            self::$connection = new PDO($dsn, DB_USER, DB_PASS, $options);
        } catch (PDOException $e) {
            self::logError($e->getMessage());
            throw $e;
        }
    }

    /**
     * Execute a prepared statement
     *
     * @param string $query SQL query with placeholders
     * @param array $params Query parameters
     * @return \PDOStatement
     * @throws PDOException
     */
    public static function prepare(string $query, array $params = []): \PDOStatement
    {
        $pdo = self::connection();
        $statement = $pdo->prepare($query);

        if (!empty($params)) {
            foreach ($params as $key => $value) {
                $paramType = self::getPDOType($value);
                $statement->bindValue(
                    is_int($key) ? $key + 1 : ':' . $key,
                    $value,
                    $paramType
                );
            }
        }

        self::logQuery($query, $params);

        return $statement;
    }

    /**
     * Execute a query and return all results
     *
     * @param string $query SQL query
     * @param array $params Query parameters
     * @return array
     * @throws PDOException
     */
    public static function fetchAll(string $query, array $params = []): array
    {
        $statement = self::prepare($query, $params);
        $statement->execute();

        return $statement->fetchAll(PDO::FETCH_ASSOC) ?: [];
    }

    /**
     * Execute a query and return a single row
     *
     * @param string $query SQL query
     * @param array $params Query parameters
     * @return array|null
     * @throws PDOException
     */
    public static function fetchOne(string $query, array $params = []): ?array
    {
        $statement = self::prepare($query, $params);
        $statement->execute();

        $result = $statement->fetch(PDO::FETCH_ASSOC);
        return $result ?: null;
    }

    /**
     * Execute a query and return a single column value
     *
     * @param string $query SQL query
     * @param array $params Query parameters
     * @param int $columnIndex Column index (default: 0)
     * @return mixed
     * @throws PDOException
     */
    public static function fetchColumn(string $query, array $params = [], int $columnIndex = 0): mixed
    {
        $statement = self::prepare($query, $params);
        $statement->execute();

        return $statement->fetchColumn($columnIndex);
    }

    /**
     * Execute an INSERT, UPDATE, or DELETE query
     *
     * @param string $query SQL query
     * @param array $params Query parameters
     * @return int Rows affected
     * @throws PDOException
     */
    public static function execute(string $query, array $params = []): int
    {
        $statement = self::prepare($query, $params);
        $statement->execute();

        return $statement->rowCount();
    }

    /**
     * Insert a record and return the last inserted ID
     *
     * @param string $table Table name
     * @param array $data Column => Value pairs
     * @return string Last inserted ID
     * @throws PDOException
     */
    public static function insert(string $table, array $data): string
    {
        $columns = array_keys($data);
        $placeholders = array_fill(0, count($columns), '?');

        $query = sprintf(
            'INSERT INTO %s (%s) VALUES (%s)',
            $table,
            implode(', ', $columns),
            implode(', ', $placeholders)
        );

        self::execute($query, array_values($data));

        return self::connection()->lastInsertId();
    }

    /**
     * Update a record
     *
     * @param string $table Table name
     * @param array $data Column => Value pairs to update
     * @param array $where WHERE clause conditions
     * @return int Rows affected
     * @throws PDOException
     */
    public static function update(string $table, array $data, array $where): int
    {
        $setClauses = array_map(fn($col) => "$col = ?", array_keys($data));
        $whereConditions = array_map(fn($col) => "$col = ?", array_keys($where));

        $query = sprintf(
            'UPDATE %s SET %s WHERE %s',
            $table,
            implode(', ', $setClauses),
            implode(' AND ', $whereConditions)
        );

        $params = array_merge(array_values($data), array_values($where));

        return self::execute($query, $params);
    }

    /**
     * Delete records
     *
     * @param string $table Table name
     * @param array $where WHERE clause conditions
     * @return int Rows affected
     * @throws PDOException
     */
    public static function delete(string $table, array $where): int
    {
        $whereConditions = array_map(fn($col) => "$col = ?", array_keys($where));

        $query = sprintf(
            'DELETE FROM %s WHERE %s',
            $table,
            implode(' AND ', $whereConditions)
        );

        return self::execute($query, array_values($where));
    }

    /**
     * Begin a transaction
     *
     * @return void
     * @throws PDOException
     */
    public static function beginTransaction(): void
    {
        $pdo = self::connection();

        if (empty(self::$transactionStack)) {
            $pdo->beginTransaction();
        } else {
            $pdo->exec('SAVEPOINT transaction_' . count(self::$transactionStack));
        }

        self::$transactionStack[] = true;
    }

    /**
     * Commit a transaction
     *
     * @return void
     * @throws PDOException
     */
    public static function commit(): void
    {
        $pdo = self::connection();

        if (count(self::$transactionStack) === 1) {
            $pdo->commit();
        } else {
            $pdo->exec('RELEASE SAVEPOINT transaction_' . (count(self::$transactionStack) - 1));
        }

        array_pop(self::$transactionStack);
    }

    /**
     * Rollback a transaction
     *
     * @return void
     * @throws PDOException
     */
    public static function rollback(): void
    {
        $pdo = self::connection();

        if (count(self::$transactionStack) === 1) {
            $pdo->rollBack();
        } else {
            $pdo->exec('ROLLBACK TO SAVEPOINT transaction_' . (count(self::$transactionStack) - 1));
        }

        array_pop(self::$transactionStack);
    }

    /**
     * Get PDO parameter type based on PHP value type
     *
     * @param mixed $value
     * @return int PDO parameter type
     */
    private static function getPDOType(mixed $value): int
    {
        return match (gettype($value)) {
            'boolean' => PDO::PARAM_BOOL,
            'integer' => PDO::PARAM_INT,
            'NULL' => PDO::PARAM_NULL,
            default => PDO::PARAM_STR,
        };
    }

    /**
     * Log a query for debugging
     *
     * @param string $query
     * @param array $params
     * @return void
     */
    private static function logQuery(string $query, array $params = []): void
    {
        if (DEBUG_MODE) {
            self::$queryLog[] = [
                'query' => $query,
                'params' => $params,
                'timestamp' => microtime(true),
            ];
        }
    }

    /**
     * Log an error
     *
     * @param string $message
     * @return void
     */
    private static function logError(string $message): void
    {
        if (LOG_ENABLED) {
            error_log($message, 3, LOG_PATH . 'database.log');
        }
    }

    /**
     * Get query log
     *
     * @return array
     */
    public static function getQueryLog(): array
    {
        return self::$queryLog;
    }

    /**
     * Clear query log
     *
     * @return void
     */
    public static function clearQueryLog(): void
    {
        self::$queryLog = [];
    }

    /**
     * Get database statistics
     *
     * @return array
     */
    public static function getStats(): array
    {
        return [
            'queries' => count(self::$queryLog),
            'transactions' => count(self::$transactionStack),
            'connected' => self::$connection !== null,
        ];
    }

    /**
     * Close the database connection
     *
     * @return void
     */
    public static function close(): void
    {
        self::$connection = null;
    }
}
