# note 026

Owner: sanitized-owner-056@example.test
Status: draft

This generated document is safe local test data for Pagepacket. It avoids customer, account, and production content.

## Summary

The file exercises Markdown editing, preview rendering, snapshot history, external-agent edits, and CLI traversal under a production-scale folder tree.

## Checklist

- [ ] Verify edit mode
- [x] Keep Markdown plain
- [ ] Review agent changes before accepting

## Table

| Area | State | Risk |
| --- | --- | --- |
| app | active | medium |
| cli | active | low |
| landing | preview | medium |

## Quote

> Human review remains the boundary before agent edits become canonical.

## Code

```sh
pagepacket-cli snapshot . product/research/note-026.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-056-000 token-056-001 token-056-002 token-056-003 token-056-004 token-056-005 token-056-006 token-056-007 token-056-008 token-056-009 token-056-010 token-056-011 token-056-012 token-056-013 token-056-014 token-056-015 token-056-016 token-056-017 token-056-018 token-056-019 token-056-020 token-056-021 token-056-022 token-056-023 token-056-024 token-056-025 token-056-026 token-056-027 token-056-028 token-056-029 token-056-030 token-056-031 token-056-032 token-056-033 token-056-034 token-056-035 token-056-036 token-056-037 token-056-038 token-056-039 token-056-040 token-056-041 token-056-042 token-056-043 token-056-044 token-056-045 token-056-046 token-056-047
