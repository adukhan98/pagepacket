# note 027

Owner: sanitized-owner-117@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-027.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-117-000 token-117-001 token-117-002 token-117-003 token-117-004 token-117-005 token-117-006 token-117-007 token-117-008 token-117-009 token-117-010 token-117-011 token-117-012 token-117-013 token-117-014 token-117-015 token-117-016 token-117-017 token-117-018 token-117-019 token-117-020 token-117-021 token-117-022 token-117-023 token-117-024 token-117-025 token-117-026 token-117-027 token-117-028 token-117-029 token-117-030 token-117-031 token-117-032 token-117-033 token-117-034 token-117-035 token-117-036 token-117-037 token-117-038 token-117-039 token-117-040 token-117-041 token-117-042 token-117-043 token-117-044 token-117-045 token-117-046 token-117-047
