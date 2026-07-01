<?php
/**
 * Base Model Class
 * 
 * Provides common functionality for all database models.
 * Handles CRUD operations, relationships, and data validation.
 * 
 * @package ElectronicsStore
 * @subpackage Core
 * @version 1.0.0
 */

namespace App\Core;

use App\Core\Database;
use Exception;

abstract class Model
{
    /**
     * Table name (must be set by child classes)
     * @var string
     */
    protected string $table = '';

    /**
     * Primary key column
     * @var string
     */
    protected string $primaryKey = 'id';

    /**
     * Fillable columns (mass assignment allowed)
     * @var array
     */
    protected array $fillable = [];

    /**
     * Hidden columns (not returned in toArray)
     * @var array
     */
    protected array $hidden = ['password_hash', 'two_factor_secret'];

    /**
     * Casts (automatic type conversion)
     * @var array
     */
    protected array $casts = [
        'id' => 'int',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Model attributes
     * @var array
     */
    protected array $attributes = [];

    /**
     * Original attributes (for dirty checking)
     * @var array
     */
    protected array $original = [];

    /**
     * Indicates if the model exists in database
     * @var bool
     */
    protected bool $exists = false;

    /**
     * Constructor
     *
     * @param array $attributes Model attributes
     */
    public function __construct(array $attributes = [])
    {
        $this->fill($attributes);
    }

    /**
     * Fill model with attributes
     *
     * @param array $attributes
     * @return $this
     */
    public function fill(array $attributes): self
    {
        foreach ($attributes as $key => $value) {
            if (empty($this->fillable) || in_array($key, $this->fillable)) {
                $this->setAttribute($key, $value);
            }
        }

        $this->original = $this->attributes;
        return $this;
    }

    /**
     * Set an attribute value
     *
     * @param string $key
     * @param mixed $value
     * @return void
     */
    public function setAttribute(string $key, mixed $value): void
    {
        $this->attributes[$key] = $this->castAttribute($key, $value);
    }

    /**
     * Get an attribute value
     *
     * @param string $key
     * @return mixed
     */
    public function getAttribute(string $key): mixed
    {
        return $this->attributes[$key] ?? null;
    }

    /**
     * Cast attribute to proper type
     *
     * @param string $key
     * @param mixed $value
     * @return mixed
     */
    protected function castAttribute(string $key, mixed $value): mixed
    {
        if (!isset($this->casts[$key]) || $value === null) {
            return $value;
        }

        return match ($this->casts[$key]) {
            'int' => (int) $value,
            'float' => (float) $value,
            'bool' => (bool) $value,
            'string' => (string) $value,
            'datetime' => $value instanceof \DateTime ? $value : new \DateTime($value),
            'json' => is_array($value) ? $value : json_decode($value, true),
            default => $value,
        };
    }

    /**
     * Magic getter
     *
     * @param string $key
     * @return mixed
     */
    public function __get(string $key): mixed
    {
        return $this->getAttribute($key);
    }

    /**
     * Magic setter
     *
     * @param string $key
     * @param mixed $value
     * @return void
     */
    public function __set(string $key, mixed $value): void
    {
        $this->setAttribute($key, $value);
    }

    /**
     * Check if attribute is set
     *
     * @param string $key
     * @return bool
     */
    public function __isset(string $key): bool
    {
        return isset($this->attributes[$key]);
    }

    /**
     * Find a model by primary key
     *
     * @param mixed $id
     * @return static|null
     */
    public static function find(mixed $id): ?static
    {
        $model = new static();
        $query = "SELECT * FROM {$model->table} WHERE {$model->primaryKey} = ?";
        $row = Database::fetchOne($query, [$id]);

        if ($row) {
            return $model->fill($row)->setExists(true);
        }

        return null;
    }

    /**
     * Find first record
     *
     * @return static|null
     */
    public static function first(): ?static
    {
        $model = new static();
        $query = "SELECT * FROM {$model->table} LIMIT 1";
        $row = Database::fetchOne($query);

        if ($row) {
            return $model->fill($row)->setExists(true);
        }

        return null;
    }

    /**
     * Get all records
     *
     * @param int $limit
     * @param int $offset
     * @return array
     */
    public static function all(int $limit = 100, int $offset = 0): array
    {
        $model = new static();
        $query = "SELECT * FROM {$model->table} LIMIT ? OFFSET ?";
        $rows = Database::fetchAll($query, [$limit, $offset]);

        return array_map(function ($row) use ($model) {
            return (new static())->fill($row)->setExists(true);
        }, $rows);
    }

    /**
     * Count records
     *
     * @return int
     */
    public static function count(): int
    {
        $model = new static();
        $query = "SELECT COUNT(*) FROM {$model->table}";
        return (int) Database::fetchColumn($query);
    }

    /**
     * Save the model
     *
     * @return bool
     */
    public function save(): bool
    {
        if ($this->exists) {
            return $this->update();
        }

        return $this->create();
    }

    /**
     * Create a new record
     *
     * @return bool
     */
    protected function create(): bool
    {
        // Remove attributes that shouldn't be inserted
        $data = array_diff_key($this->attributes, [
            $this->primaryKey => null
        ]);

        $id = Database::insert($this->table, $data);
        $this->setAttribute($this->primaryKey, $id);
        $this->setExists(true);

        return true;
    }

    /**
     * Update existing record
     *
     * @return bool
     */
    protected function update(): bool
    {
        $primaryKeyValue = $this->getAttribute($this->primaryKey);

        Database::update(
            $this->table,
            $this->attributes,
            [$this->primaryKey => $primaryKeyValue]
        );

        return true;
    }

    /**
     * Delete the model
     *
     * @return bool
     */
    public function delete(): bool
    {
        if (!$this->exists) {
            return false;
        }

        $primaryKeyValue = $this->getAttribute($this->primaryKey);
        Database::delete($this->table, [$this->primaryKey => $primaryKeyValue]);

        return true;
    }

    /**
     * Set exists flag
     *
     * @param bool $exists
     * @return $this
     */
    public function setExists(bool $exists): self
    {
        $this->exists = $exists;
        return $this;
    }

    /**
     * Check if attribute has been modified
     *
     * @param string $key
     * @return bool
     */
    public function isDirty(string $key): bool
    {
        return $this->attributes[$key] !== ($this->original[$key] ?? null);
    }

    /**
     * Get dirty attributes
     *
     * @return array
     */
    public function getDirty(): array
    {
        $dirty = [];

        foreach ($this->attributes as $key => $value) {
            if ($value !== ($this->original[$key] ?? null)) {
                $dirty[$key] = $value;
            }
        }

        return $dirty;
    }

    /**
     * Convert model to array
     *
     * @return array
     */
    public function toArray(): array
    {
        $array = $this->attributes;

        foreach ($this->hidden as $key) {
            unset($array[$key]);
        }

        return $array;
    }

    /**
     * Convert model to JSON
     *
     * @return string
     */
    public function toJson(): string
    {
        return json_encode($this->toArray());
    }
}
