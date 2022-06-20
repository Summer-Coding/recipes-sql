create trigger on_auth_user_updated
  after update on auth.users
  for each row execute procedure public.handle_updated_user();