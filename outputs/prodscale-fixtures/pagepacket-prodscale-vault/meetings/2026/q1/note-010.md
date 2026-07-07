# note 010

Owner: sanitized-owner-160@example.test
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
pagepacket-cli snapshot . meetings/2026/q1/note-010.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-160-000 token-160-001 token-160-002 token-160-003 token-160-004 token-160-005 token-160-006 token-160-007 token-160-008 token-160-009 token-160-010 token-160-011 token-160-012 token-160-013 token-160-014 token-160-015 token-160-016 token-160-017 token-160-018 token-160-019 token-160-020 token-160-021 token-160-022 token-160-023 token-160-024 token-160-025 token-160-026 token-160-027 token-160-028 token-160-029 token-160-030 token-160-031 token-160-032 token-160-033 token-160-034 token-160-035 token-160-036 token-160-037 token-160-038 token-160-039 token-160-040 token-160-041 token-160-042 token-160-043 token-160-044 token-160-045 token-160-046 token-160-047
