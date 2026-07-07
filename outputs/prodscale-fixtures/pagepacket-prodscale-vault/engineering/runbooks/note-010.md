# note 010

Owner: sanitized-owner-100@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-010.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-100-000 token-100-001 token-100-002 token-100-003 token-100-004 token-100-005 token-100-006 token-100-007 token-100-008 token-100-009 token-100-010 token-100-011 token-100-012 token-100-013 token-100-014 token-100-015 token-100-016 token-100-017 token-100-018 token-100-019 token-100-020 token-100-021 token-100-022 token-100-023 token-100-024 token-100-025 token-100-026 token-100-027 token-100-028 token-100-029 token-100-030 token-100-031 token-100-032 token-100-033 token-100-034 token-100-035 token-100-036 token-100-037 token-100-038 token-100-039 token-100-040 token-100-041 token-100-042 token-100-043 token-100-044 token-100-045 token-100-046 token-100-047
