# Auth Users

Not to be confused with public.users - this is a table/schema created by Supabase to maintain their auth API.

Currently, the relevant data structure looks something like this:

```json
// auth.users
{
  "email": "test@test.com",
  "id": "00000000-0000-0000-0000-000000000000",
  "user_metadata": {
    "roles": ["USER","ADMIN"], // default is just ["USER"]
    "username": "example" // created when profile is created
  }
  // much more data that is not being tracked in public table
}
```

This table isn't able to be interfaced with in the Recipes API, so the public.users table exists to a) flatten this data and b) use with queries in the API. The example dataset looks like this:

```json
// public.users
{
  "email": "test@test.com",
  "id": "00000000-0000-0000-0000-000000000000",
  "roles": "{USER,ADMIN}", // using enums (public.role)
  "is_active": true, // default true
  "created_at": "2022-06-19 22:00:00.000", // defaults to now()
  "updated_at": "2022-06-19 23:00:00.000", // nullable
}
```

## Functions

The functions work as an interface for the triggers to help separate the logic from the trigger itself. The triggers sync the data after insert, update, and delete. On delete, it doesn't delete the user from the table, just switches is_active to false.
