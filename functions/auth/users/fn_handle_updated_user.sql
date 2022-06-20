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