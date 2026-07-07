# note 011

Owner: sanitized-owner-101@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-011.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-101-000 token-101-001 token-101-002 token-101-003 token-101-004 token-101-005 token-101-006 token-101-007 token-101-008 token-101-009 token-101-010 token-101-011 token-101-012 token-101-013 token-101-014 token-101-015 token-101-016 token-101-017 token-101-018 token-101-019 token-101-020 token-101-021 token-101-022 token-101-023 token-101-024 token-101-025 token-101-026 token-101-027 token-101-028 token-101-029 token-101-030 token-101-031 token-101-032 token-101-033 token-101-034 token-101-035 token-101-036 token-101-037 token-101-038 token-101-039 token-101-040 token-101-041 token-101-042 token-101-043 token-101-044 token-101-045 token-101-046 token-101-047
