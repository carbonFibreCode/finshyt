-- 1. create demo user if it doesn’t exist
do $$
declare
  usr_id uuid;
begin
  select id into usr_id
  from auth.users
  where email = 'demo@user.com';

  if usr_id is null then
    usr_id := (select id
               from auth.admin_create_user(
                 email       := 'demo@user.com',
                 password    := 'demo123',
                 email_confirm := true));
  end if;

  -- 2. insert expenses belonging to that user
  insert into public.expenses (user_id, amount, purpose, ts) values
    (usr_id, 12.75, 'Coffee',      now() - interval '6 days'),
    (usr_id, 48.20, 'Groceries',   now() - interval '5 days'),
    (usr_id, 90.00, 'Dining Out',  now() - interval '2 days'),
    (usr_id, 39.99, 'OnlineCourse',now() - interval '1 day')
  on conflict do nothing;
end $$;
