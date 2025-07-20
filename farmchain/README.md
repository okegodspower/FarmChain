# 🌾 FarmChain

**FarmChain** is a Web3 supply chain app built on the Stacks blockchain using Clarity smart contracts. It helps track farm products from harvest to delivery and ensures fair payment to farmers.

---

## 🧱 Smart Contracts

### 1. `crop-registry.clar`
- Registers new crop batches
- Stores crop type, harvest date, location, and certification hash

### 2. `logistics-tracker.clar`
- Records checkpoints in the delivery process
- Each checkpoint includes location and timestamp

### 3. `escrow-payments.clar`
- Holds funds in escrow
- Releases payment when delivery is confirmed

---

## 🚀 Getting Started

### Install Clarinet

```bash
npm install -g @hirosystems/clarinet
```

