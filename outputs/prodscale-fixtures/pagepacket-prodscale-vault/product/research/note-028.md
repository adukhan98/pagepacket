# note 028

Owner: sanitized-owner-058@example.test
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
pagepacket-cli snapshot . product/research/note-028.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-058-000 token-058-001 token-058-002 token-058-003 token-058-004 token-058-005 token-058-006 token-058-007 token-058-008 token-058-009 token-058-010 token-058-011 token-058-012 token-058-013 token-058-014 token-058-015 token-058-016 token-058-017 token-058-018 token-058-019 token-058-020 token-058-021 token-058-022 token-058-023 token-058-024 token-058-025 token-058-026 token-058-027 token-058-028 token-058-029 token-058-030 token-058-031 token-058-032 token-058-033 token-058-034 token-058-035 token-058-036 token-058-037 token-058-038 token-058-039 token-058-040 token-058-041 token-058-042 token-058-043 token-058-044 token-058-045 token-058-046 token-058-047
