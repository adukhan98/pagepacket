# note 026

Owner: sanitized-owner-026@example.test
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
pagepacket-cli snapshot . product/specs/note-026.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-026-000 token-026-001 token-026-002 token-026-003 token-026-004 token-026-005 token-026-006 token-026-007 token-026-008 token-026-009 token-026-010 token-026-011 token-026-012 token-026-013 token-026-014 token-026-015 token-026-016 token-026-017 token-026-018 token-026-019 token-026-020 token-026-021 token-026-022 token-026-023 token-026-024 token-026-025 token-026-026 token-026-027 token-026-028 token-026-029 token-026-030 token-026-031 token-026-032 token-026-033 token-026-034 token-026-035 token-026-036 token-026-037 token-026-038 token-026-039 token-026-040 token-026-041 token-026-042 token-026-043 token-026-044 token-026-045 token-026-046 token-026-047
