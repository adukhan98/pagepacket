# note 018

Owner: sanitized-owner-078@example.test
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
pagepacket-cli snapshot . engineering/rfcs/note-018.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-078-000 token-078-001 token-078-002 token-078-003 token-078-004 token-078-005 token-078-006 token-078-007 token-078-008 token-078-009 token-078-010 token-078-011 token-078-012 token-078-013 token-078-014 token-078-015 token-078-016 token-078-017 token-078-018 token-078-019 token-078-020 token-078-021 token-078-022 token-078-023 token-078-024 token-078-025 token-078-026 token-078-027 token-078-028 token-078-029 token-078-030 token-078-031 token-078-032 token-078-033 token-078-034 token-078-035 token-078-036 token-078-037 token-078-038 token-078-039 token-078-040 token-078-041 token-078-042 token-078-043 token-078-044 token-078-045 token-078-046 token-078-047
