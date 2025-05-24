import { test, expect } from '@playwright/test';

test('is defined', async ({ page }) => {
  await page.goto('/');

  expect(page).toBeDefined();
});
