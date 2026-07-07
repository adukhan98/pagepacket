# note 026

Owner: sanitized-owner-326@example.test
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
pagepacket-cli snapshot . nested/very/deep/workspace/note-026.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-326-000 token-326-001 token-326-002 token-326-003 token-326-004 token-326-005 token-326-006 token-326-007 token-326-008 token-326-009 token-326-010 token-326-011 token-326-012 token-326-013 token-326-014 token-326-015 token-326-016 token-326-017 token-326-018 token-326-019 token-326-020 token-326-021 token-326-022 token-326-023 token-326-024 token-326-025 token-326-026 token-326-027 token-326-028 token-326-029 token-326-030 token-326-031 token-326-032 token-326-033 token-326-034 token-326-035 token-326-036 token-326-037 token-326-038 token-326-039 token-326-040 token-326-041 token-326-042 token-326-043 token-326-044 token-326-045 token-326-046 token-326-047
