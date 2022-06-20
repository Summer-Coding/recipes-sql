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