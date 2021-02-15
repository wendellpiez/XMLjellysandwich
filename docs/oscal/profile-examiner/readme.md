# OSCAL Profile Checker

A client-side validation utility for OSCAL Profiles

The utility loads the SP800-53 rev 5 catalog and checks your profile against it

checking a profile against SP800-53 catalog

it assumes a schema-valid OSCAL profile instance, although some defensiveness is provided against inputs that are invalid, mainly for demonstration.

In a second pass, results can be assessed for a summary view / analytic conclusion
(green check box if no red results are found!)

A Metaschema-driven XSLT validator will come in another project. This validator
is written entirely by hand to demonstrate the concept.

- [ ] Is SP800-53 imported?
- [ ] Any orphan / dangling references? controls, parameters, patches

- [ ] Import check (per import)
  - [ ] the import appears to call SP800-53 ...
  - [ ] the import actually calls ... 
  - [ ] none of the controls call controls in SP 800-53 rev 5 (by control-id)
  - [ ] all control-ids match up
  - [ ] no replicates or redundancy among calls (by control-id)
  - [ ] Add support for @match
  - [ ] Render - inputs and results of selection (control listing)
- [ ] Merge inspection
  - [ ] Show structure of result (profile when resolved) 
  - [ ] Were any controls dropped  
- [ ] Parameters
  - [ ] param-ids match up
  - [ ] parameters referenced in the control that are *not* addressed in the profile
  - [ ] Render - collapsed (rendered) parameters in the contexts of their use
- [ ] Patches
  - [ ] target IDs match up 
  - [ ] show control text before and after patch
