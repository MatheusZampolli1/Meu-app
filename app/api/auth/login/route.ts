import { NextResponse } from 'next/server';
import { buildAuthToken, getAuthCookieName, isPasswordValid } from '@/lib/auth';

export async function POST(request: Request) {
  const { password } = await request.json();
  if (!isPasswordValid(password)) {
    return NextResponse.json({ success: false, message: 'Senha inválida' }, { status: 401 });
  }

  const response = NextResponse.json({ success: true });
  response.cookies.set(getAuthCookieName(), buildAuthToken(password), {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    path: '/'
  });

  return response;
}
