# Screen 02 — Phone Login

## SRS Reference
§8.1 Phone Login

## Routes
- Entry: `/login`
- Exit: `/otp` on successful OTP request

## Behavior
- Indian phone number (+91 preset)
- 10-digit validation before continue
- Calls `requestOtp` repo method
- No password field

## API Contract
- `POST /otp/request` `{ phone: string }` → `{ status: true, message: string }`

## Acceptance
- [ ] +91 country code visible
- [ ] Invalid phone blocked
- [ ] OTP request called before navigation
- [ ] Loading state on CTA
