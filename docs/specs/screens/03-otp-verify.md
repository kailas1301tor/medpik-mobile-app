# Screen 03 — OTP Verify

## SRS Reference
§8.1 OTP Verify

## Routes
- Entry: `/otp`
- Exit: `/main` on success
- Blocked: suspended users stay on screen with error

## Behavior
- 6-digit OTP input
- Resend with 60s countdown
- Verify creates session tokens
- Suspended account blocked

## API Contract
- `POST /otp/verify` `{ phone, otp }` → `AuthModel`
- Test OTP: `123456`
- Suspended phone: `9999999999`

## Acceptance
- [ ] Shows masked phone with +91
- [ ] Resend disabled during countdown
- [ ] Valid OTP navigates to main
- [ ] Suspended user cannot proceed
