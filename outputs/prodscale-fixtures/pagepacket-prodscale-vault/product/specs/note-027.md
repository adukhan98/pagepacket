# note 027

Owner: sanitized-owner-027@example.test
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
pagepacket-cli snapshot . product/specs/note-027.md --message "Before agent edits"
```

![Sample asset](../assets/shared/sample.ppm)

---

A deliberately long line follows so the editor wrapping path is exercised without horizontal scrolling: token-027-000 token-027-001 token-027-002 token-027-003 token-027-004 token-027-005 token-027-006 token-027-007 token-027-008 token-027-009 token-027-010 token-027-011 token-027-012 token-027-013 token-027-014 token-027-015 token-027-016 token-027-017 token-027-018 token-027-019 token-027-020 token-027-021 token-027-022 token-027-023 token-027-024 token-027-025 token-027-026 token-027-027 token-027-028 token-027-029 token-027-030 token-027-031 token-027-032 token-027-033 token-027-034 token-027-035 token-027-036 token-027-037 token-027-038 token-027-039 token-027-040 token-027-041 token-027-042 token-027-043 token-027-044 token-027-045 token-027-046 token-027-047
