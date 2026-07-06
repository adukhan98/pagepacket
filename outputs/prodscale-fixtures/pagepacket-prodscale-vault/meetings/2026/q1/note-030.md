# note 030

Owner: sanitized-owner-180@example.test
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
pagepacket-cli snapshot . meetings/2026/q1/note-030.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-180-000 token-180-001 token-180-002 token-180-003 token-180-004 token-180-005 token-180-006 token-180-007 token-180-008 token-180-009 token-180-010 token-180-011 token-180-012 token-180-013 token-180-014 token-180-015 token-180-016 token-180-017 token-180-018 token-180-019 token-180-020 token-180-021 token-180-022 token-180-023 token-180-024 token-180-025 token-180-026 token-180-027 token-180-028 token-180-029 token-180-030 token-180-031 token-180-032 token-180-033 token-180-034 token-180-035 token-180-036 token-180-037 token-180-038 token-180-039 token-180-040 token-180-041 token-180-042 token-180-043 token-180-044 token-180-045 token-180-046 token-180-047
