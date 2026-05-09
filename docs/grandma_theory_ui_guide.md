# Grandma Theory — UI Design Guide

## Core Principle

Design every screen as if your grandmother — who has never used a smartphone —
will use it alone, in a quiet room, without any help.

If she can understand it, anyone can.

---

## Visual Design Rules

### Text
- Body text: minimum **18sp**
- Headlines: minimum **24sp**
- Never use light gray on white — must pass WCAG AA contrast
- Use **Bengali** as primary language everywhere

### Buttons
- Minimum height: **56dp** (easy to tap with arthritic fingers)
- Clear label — no icon-only buttons
- One primary action per screen
- Use rounded corners (soft, friendly feel)

### Colors
| Purpose | Color | Why |
|---|---|---|
| Primary | `#4CAF82` (soft green) | Nature, health, calm |
| Background | `#FAFAFA` (warm white) | Easy on eyes |
| Card | `#FFFFFF` | Clean separation |
| High score | `#4CAF50` (green) | Positive, not alarming |
| Medium score | `#FFA726` (warm orange) | Attention, not scary |
| Low score | `#78909C` (blue-gray) | Neutral, not red/alarming |
| Text primary | `#212121` | High contrast |
| Text secondary | `#757575` | Supporting info |

**NEVER use red for health scores.** Red triggers fear.
Use calm blue-gray instead for low scores.

### Icons
- Use large, recognizable icons (minimum 32dp)
- Avoid medical symbols (stethoscopes, ECG waves, pill icons)
- Prefer everyday images: microphone, walking figure, keyboard

---

## Language Rules

### Write like a caring family member, not a doctor.

| Instead of... | Say... |
|---|---|
| "Vocal tremor detected" | "আজ কণ্ঠ একটু নরম ছিল" |
| "Abnormal gait pattern" | "হাঁটার গতি একটু ধীর ছিল" |
| "Cognitive decline risk" | "আজ মনোযোগ দিতে একটু কষ্ট হয়েছে মনে হচ্ছে" |
| "Low score alert" | "আজ একটু বিশ্রাম নেওয়া ভালো" |
| "Consult physician" | "প্রয়োজনে একজন ডাক্তারের সাথে কথা বলুন" |

### Score messages (Bengali examples)

**High score (70–100):**
> আজ আপনার কণ্ঠ বেশ স্থির ছিল। খুব ভালো! এভাবেই চালিয়ে যান।

**Medium score (40–69):**
> আজ একটু কম ভালো মনে হয়েছে। একটু বিশ্রাম নিন। পানি খান। কাল আবার দেখুন।

**Low score (0–39):**
> আজ একটু কম ছিল। চিন্তা করবেন না। কয়েক দিন এমন হলে, ডাক্তারের সাথে কথা বলুন।

---

## Screen-by-Screen Guidelines

### Home Screen
```
┌─────────────────────────┐
│   Sapience AI           │
│   আসসালামু আলাইকুম     │
│   [User name]           │
│                         │
│  [কণ্ঠ পরীক্ষা করুন]  │  ← Big green button
│  [হাঁটার পরীক্ষা করুন] │  ← Big green button
│  [টাইপিং পরীক্ষা করুন] │  ← Big green button
│                         │
│  আজকের সংক্ষেপ: ভালো   │  ← Simple summary
└─────────────────────────┘
```

### Result Screen
```
┌─────────────────────────┐
│   কণ্ঠ বিশ্লেষণ        │
│                         │
│        82               │  ← Big score number
│      / ১০০              │
│                         │
│   আজ আপনার কণ্ঠ বেশ   │
│   স্থির ছিল। খুব ভালো! │  ← Calm Bengali message
│                         │
│  [বাড়ি ফিরুন]          │  ← Single action button
└─────────────────────────┘
```

### History Screen
- Show last 7 days as simple colored dots (green / orange / gray)
- No complex line charts for elderly users
- Optional: simple bar chart for tech-savvy users

---

## Notifications (Gentle Only)

**Daily reminder (evening):**
> "আজ কি পরীক্ষা করা হয়েছে? 🌿"

**Streak message:**
> "টানা ৭ দিন পরীক্ষা করেছেন! অসাধারণ!"

**NEVER send:**
- "Warning: Low score detected"
- "Alert: Health anomaly"
- "Critical: Consult doctor immediately"

Instead, within the app, gently show:
> "কয়েক দিন ধরে একটু কম আসছে। প্রয়োজনে ডাক্তারের সাথে কথা বলুন।"

---

## Accessibility

- Support system font size scaling
- Support dark mode (use semantic color tokens, not hardcoded hex)
- Minimum tap target: 48×48dp (Material guideline)
- Voice-over / TalkBack friendly labels on all interactive elements
