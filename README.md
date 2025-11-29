# Pixeltime

A pixel art creator.

## Development

### Database Migrations

In order to handle the data for Pixeltime, we rely on SQLite3. We support database migration through a blend of a script to create and generate the migrations and automatically running them when the applications starts. Any model that you want to be stored in the database, must go through the create and generate processes first.

#### Creating a Migration

To create a migration run:

```shell
dart run scripts/migrations.dart create --name <name>
```

Replacing the `<name>` variable with a name that you choose. For example:

```shell
dart run scripts/migrations.dart create --name add_projects
```

This creates an `up` and `down` sql file for you in the `migrations` folder. Edit it with appropriate SQL and save it.

#### Generating Migrations

The content of the `migrations` folder is generated into `dart` code with the `generate` command:

```shell
dart run scripts/migrations.dart generate
```

This stores the resulting generated content in the `lib/migrations/generated.dart` file.
