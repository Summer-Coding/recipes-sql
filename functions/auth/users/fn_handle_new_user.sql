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