const AUTH_COOKIE = 'finance_auth';

export function getAuthCookieName() {
  return AUTH_COOKIE;
}

export function buildAuthToken(password: string) {
  return `ok:${password}`;
}

export function isPasswordValid(input: string) {
  const appPassword = process.env.APP_PASSWORD;
  if (!appPassword) return false;
  return input === appPassword;
}

export function getExpectedToken() {
  const appPassword = process.env.APP_PASSWORD;
  if (!appPassword) return '';
  return buildAuthToken(appPassword);
}
