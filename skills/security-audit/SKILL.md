---
name: security-audit
description: Security Audit
disable-model-invocation: true
---

# Security Audit

## Overview
Comprehensive security review to identify and fix vulnerabilities in the codebase.

## Steps
1. **Dependency audit**
   - Check for known vulnerabilities
   - Update outdated packages
   - Review third-party dependencies

2. **Code security review**
   1. Identify security-sensitive code paths
   2. Check for common vulnerabilities (injection, XSS, auth bypass)
   3. Verify secrets are not hardcoded
   4. Review input validation and sanitization

3. **Infrastructure security**
   - Review environment variables
   - Check access controls
   - Audit network security

4. Report findings by severity:
- Critical (must fix before deploy)
- High (fix soon)
- Medium (address when possible)

## Security Checklist
- [ ] Dependencies updated and secure
- [ ] No hardcoded secrets
- [ ] Input validation implemented
- [ ] Authentication secure
- [ ] Authorization properly configured
