# Screen 04 — Home

## SRS Reference
§8.2 Home

## Routes
- Entry: Main tab index 0
- Location tap → Address Book
- Search tap → Search screen
- Prescription CTA → Prescription Upload
- Category / See all → Search Results

## Sections
- Fixed pinned top header with `primary_background.png` from the status bar through the search bar
- Greeting with user name + notification bell
- Delivery location hint with chevron (`Home · Mumbai, 400001`)
- Search entry with scan icon (read-only placeholder until Search screen)
- Prescription upload banner (horizontal, trust badges, Upload Now)
- Offers carousel with pagination dots
- Shop by category — circular icon row
- Popular products — liquid glass horizontal carousel (~2.2 cards visible, snapping) with hero product imagery, discount badge, wishlist, glass CTA morphing to qty selector

## Mock Contract
- `GET /home` → `HomeFeedModel`
- `OfferModel` includes optional `badgeLabel`, `promoCode`
- `ProductModel` includes optional `mrp`, `discountPercent`, `packSize`

## Acceptance
- [ ] Loads home feed with shimmer matching the pinned header layout
- [ ] Shows pinned header with background image covering the status bar area
- [ ] Shows greeting, bell, location chevron, search with scan icon
- [ ] Prescription banner horizontal with Quick/Safe/Reliable badges
- [ ] Offers carousel with cream card, promo code, dot pagination
- [ ] Categories as circular icons in horizontal row
- [ ] Popular products liquid glass carousel with snapping, hero images, wishlist, glass add/qty CTA wired to cart
- [ ] Error/empty states via CommonSwitchState
- [ ] Rx upload CTA navigates to prescription upload
- [ ] Header remains pinned while the rest of the feed scrolls
