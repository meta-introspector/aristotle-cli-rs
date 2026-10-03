// Kant Network Utilities - MIT License

class KantNet {
  constructor() {}

  static parseShareUrl(shareUrl) {
    if (!shareUrl) return null;
    
    // Parse Kant share URL format
    const match = shareUrl.match(/#([^\s]+)/);
    if (!match) return null;
    
    return {
      type: 'KantShare',
      data: match[1]
    };
  }

  static fetchFile(url) {
    // Mock fetch for testing
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve('Mock file content');
      }, 100);
    });
  }

  static postToRelay(relayUrl, data, options = {}) {
    // Mock POST to relay
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve({
          status: 200,
          json: () => ({ cursor: 1 })
        });
      }, 100);
    });
  }

  static async getPasteUrl(relayUrl) {
    return relayUrl + '/paste';
  }
}

module.exports = KantNet;