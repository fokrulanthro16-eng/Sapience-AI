# Sapience AI — Privacy Policy Draft

**Version:** 0.1 (Draft — not yet legally reviewed)
**Last updated:** 2026-05-09

---

## 1. What We Collect

Sapience AI collects the following data:

### On Your Device (Local Only)
- Audio recordings (temporary — deleted immediately after analysis)
- Keystroke timing data (stored locally in encrypted SQLite database)
- Accelerometer readings (stored locally in encrypted SQLite database)
- Wellness scores computed from the above

### In the Cloud
- Your email address (for account login via Supabase Auth)
- Encrypted wellness summaries (numbers and short encrypted text)
- Stability scores (0–100 integers)

**We do NOT collect:**
- Raw audio files in the cloud
- Raw keystroke logs in the cloud
- Raw accelerometer data in the cloud
- Any personally identifiable health data beyond what you explicitly sync

---

## 2. How We Use Your Data

- To show you your wellness trends over time
- To generate calm, encouraging Bengali wellness advice on your device
- To allow you to access your history across devices (cloud sync)

We do **not**:
- Sell your data to third parties
- Use your data for advertising
- Share your data with health insurers or employers
- Use your data to train AI models without explicit consent

---

## 3. Where Your Data Lives

| Data | Location | Who can see it |
|---|---|---|
| Raw audio | Your device only (temp) | Only you |
| Raw typing/gait | Your device SQLite | Only you |
| Encrypted summaries | Supabase cloud | Only you (RLS enforced) |
| Account email | Supabase Auth | Supabase + you |

Cloud data is protected by Supabase Row Level Security (RLS).
Even our own backend cannot read another user's rows.

---

## 4. Your Rights

- **Access**: You can export all your data at any time
- **Deletion**: You can delete your account and all associated data
- **Correction**: You can update your profile information
- **Portability**: Local SQLite data is on your device — you own it

---

## 5. Data Retention

- Cloud data is retained until you delete your account
- Local data is retained until you uninstall the app or clear app data
- Temporary audio files are deleted within seconds of analysis

---

## 6. Medical Disclaimer

**Sapience AI is not a medical device.**
It does not diagnose, treat, cure, or prevent any disease or health condition.
All output is for personal wellness awareness only.
If you have health concerns, please consult a qualified healthcare professional.

---

## 7. Children

Sapience AI is not intended for children under 13.
We do not knowingly collect data from children.

---

## 8. Changes to This Policy

We will notify users of material changes to this policy
by updating the version date above and notifying via the app.

---

## 9. Contact

For privacy questions: [your contact email here]

---

*This is a draft policy. Have it reviewed by a legal professional
before publishing the app publicly.*
