# note 018

Owner: sanitized-owner-108@example.test
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
pagepacket-cli snapshot . engineering/runbooks/note-018.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-108-000 token-108-001 token-108-002 token-108-003 token-108-004 token-108-005 token-108-006 token-108-007 token-108-008 token-108-009 token-108-010 token-108-011 token-108-012 token-108-013 token-108-014 token-108-015 token-108-016 token-108-017 token-108-018 token-108-019 token-108-020 token-108-021 token-108-022 token-108-023 token-108-024 token-108-025 token-108-026 token-108-027 token-108-028 token-108-029 token-108-030 token-108-031 token-108-032 token-108-033 token-108-034 token-108-035 token-108-036 token-108-037 token-108-038 token-108-039 token-108-040 token-108-041 token-108-042 token-108-043 token-108-044 token-108-045 token-108-046 token-108-047
