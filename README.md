# Gather

## TODO

Migrate from [ocaml](https://github.com/jakequinter/gather/tree/ocaml)

### Server

- [x] setup db
  - [x] users
  - [x] guests
- [ ] setup auth
  - [x] users/register -> register
  - [x] users/login -> login
  - [ ] users/reset_password -> reset_password
  - [ ] users/reset_password/:token -> reset_password/:token
  - [ ] users/settings -> settings
  - [ ] users/settings/confirm_email -> settings/confirm_email/:token
  - [ ] users/log_out -> log_out
  - [ ] users/confrim/:token -> confirm/:token
  - [ ] users/confirm -> confim

### Client

- [x] auth routes
- [ ] guest routes
  - [x] GET (`/guests`)
  - [x] POST (`/guests`) -> `create_guest`
  - [ ] PUT (`/guests`) -> `update_guest`
  - [x] DELETE (`/guests`) -> `delete_guest`
- [ ] search

### Tests

- [x] users
- [x] guests
