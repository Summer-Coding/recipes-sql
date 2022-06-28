-- delete user
create or replace function public.handle_deleted_user()
returns trigger as $$
begin
  update public.users
  set is_active = false
  where id = old.id;
  update public.profiles
  set is_active = false
  where user_id = old.id;
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_deleted
  after delete on auth.users
  for each row execute procedure public.handle_deleted_user();




-- new user
create or replace function public.handle_new_user() 
returns trigger as $$
begin
  insert into public.users (id, email, is_active, roles)
  values (
    new.id, 
    new.email, 
    true, 
    CONCAT('{', (
      select string_agg(value::text, ',') 
      from json_array_elements_text(new.raw_user_meta_data::json -> 'roles')
    ), '}')::public.role[]
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
 



-- update user
create or replace function public.handle_updated_user()
returns trigger as $$
begin
  update public.users as u
  set 
    email = new.email,
    roles = 
      CONCAT('{', (
        select string_agg(value::text, ',') 
        from json_array_elements_text(new.raw_user_meta_data::json -> 'roles')
      ), '}')::public.role[]
  where u.id = old.id;
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_updated
  after update on auth.users
  for each row execute procedure public.handle_updated_user();
