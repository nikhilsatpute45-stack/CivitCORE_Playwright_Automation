/**
 * Audit Trail hooks.
 *
 * After: closes a Clear Log confirmation dialog a failed step may have left open, WITHOUT confirming it, so the next scenario starts clean.
 * There is deliberately no data clean-up or baseline re-seed here: audit entries are written by the system, and the product exposes no
 * way to recreate or back-date them (see AuditTrailApi). Scenarios that confirm a Clear Log are gated by AUDIT_TRAIL_ALLOW_DESTRUCTIVE;
 * after such a run the environment's baseline must be re-seeded by hand before the next one (workbook Summary note 3).
 */
import { After } from '@cucumber/cucumber';
import type { CustomWorld } from '../../support/world';
import { auditPages, auditScenario } from '../../support/audit-trail-scenario';

After({ tags: '@AuditTrail', name: 'Close the Audit Trail dialog without confirming' }, async function (this: CustomWorld) {
  if (!this.hasPage || this.page.isClosed()) return;
  try {
    await auditPages(this).dialog.dismiss();
  } catch (error) {
    this.log(`Audit Trail dialog clean-up failed: ${(error as Error).message}`);
  }
  if (auditScenario(this).clearOutcome === 'confirmed') {
    this.log('A Clear Log was confirmed in this scenario: re-seed the Audit Trail baseline before the next run (workbook Summary note 3).');
  }
});
