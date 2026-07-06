# note 027

Owner: sanitized-owner-057@example.test
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
pagepacket-cli snapshot . product/research/note-027.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-057-000 token-057-001 token-057-002 token-057-003 token-057-004 token-057-005 token-057-006 token-057-007 token-057-008 token-057-009 token-057-010 token-057-011 token-057-012 token-057-013 token-057-014 token-057-015 token-057-016 token-057-017 token-057-018 token-057-019 token-057-020 token-057-021 token-057-022 token-057-023 token-057-024 token-057-025 token-057-026 token-057-027 token-057-028 token-057-029 token-057-030 token-057-031 token-057-032 token-057-033 token-057-034 token-057-035 token-057-036 token-057-037 token-057-038 token-057-039 token-057-040 token-057-041 token-057-042 token-057-043 token-057-044 token-057-045 token-057-046 token-057-047
