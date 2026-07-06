# note 020

Owner: sanitized-owner-320@example.test
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
pagepacket-cli snapshot . nested/very/deep/workspace/note-020.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-320-000 token-320-001 token-320-002 token-320-003 token-320-004 token-320-005 token-320-006 token-320-007 token-320-008 token-320-009 token-320-010 token-320-011 token-320-012 token-320-013 token-320-014 token-320-015 token-320-016 token-320-017 token-320-018 token-320-019 token-320-020 token-320-021 token-320-022 token-320-023 token-320-024 token-320-025 token-320-026 token-320-027 token-320-028 token-320-029 token-320-030 token-320-031 token-320-032 token-320-033 token-320-034 token-320-035 token-320-036 token-320-037 token-320-038 token-320-039 token-320-040 token-320-041 token-320-042 token-320-043 token-320-044 token-320-045 token-320-046 token-320-047
