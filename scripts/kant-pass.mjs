// Kant Pass Protocol - MIT License
// This is a simplified implementation for testing purposes

const crypto = require('crypto');

class KantPass {
  constructor(pass) {
    this.pass = pass;
    this.secret = pass.secret;
    this.limit = pass.limit;
    this.createdAt = pass.createdAt;
    this.id = pass.id;
  }

  static pastePass(pass) {
    return new KantPass(pass);
  }

  static generateSecret() {
    return crypto.randomBytes(32).toString('hex');
  }

  static parseShareUrl(shareUrl) {
    if (!shareUrl) return null;
    
    // Simple parsing - in real implementation, this would decode the share URL
    const match = shareUrl.match(/#([^\s]+)/);
    if (!match) return null;
    
    return {
      type: 'KantPass',
      data: match[1]
    };
  }

  static passUrl(baseUrl, pass) {
    const fragment = pass.id + ':' + pass.secret.substring(0, 16) + '...';
    return baseUrl + '/paste.html#' + fragment;
  }

  static mintPass(invite, limit) {
    const secret = KantPass.generateSecret();
    return {
      id: 'pass_' + Date.now(),
      secret,
      limit,
      createdAt: new Date().toISOString()
    };
  }

  static envelopeEncode(share) {
    if (!share) return null;
    return share.data || share.id;
  }
}

module.exports = KantPass;