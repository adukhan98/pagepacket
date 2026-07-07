# note 023

Owner: sanitized-owner-113@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-023.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-113-000 token-113-001 token-113-002 token-113-003 token-113-004 token-113-005 token-113-006 token-113-007 token-113-008 token-113-009 token-113-010 token-113-011 token-113-012 token-113-013 token-113-014 token-113-015 token-113-016 token-113-017 token-113-018 token-113-019 token-113-020 token-113-021 token-113-022 token-113-023 token-113-024 token-113-025 token-113-026 token-113-027 token-113-028 token-113-029 token-113-030 token-113-031 token-113-032 token-113-033 token-113-034 token-113-035 token-113-036 token-113-037 token-113-038 token-113-039 token-113-040 token-113-041 token-113-042 token-113-043 token-113-044 token-113-045 token-113-046 token-113-047
