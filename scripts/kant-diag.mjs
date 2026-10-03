// Kant Diagnostics - MIT License

class KantDiag {
  constructor() {}

  static print(message) {
    console.log(`[KantDIAG] ${message}`);
  }

  static error(message) {
    console.error(`[KantDIAG] ${message}`);
  }

  static success(message) {
    console.log(`[KantDIAG] ✅ ${message}`);
  }

  static warn(message) {
    console.log(`[KantDIAG] ⚠️ ${message}`);
  }

  static debug(message) {
    console.log(`[KantDIAG] 🔍 ${message}`);
  }
}

module.exports = KantDiag;