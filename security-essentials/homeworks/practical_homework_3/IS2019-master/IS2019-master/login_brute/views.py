from django.shortcuts import render
from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout as main_logout


# Create your views here.


def signin_page(request):
    login_try_count = request.COOKIES.get('login_try_count', 0)
    if not str(login_try_count).isdigit():
        login_try_count = 0
    login_try_count = int(login_try_count)
    has_captcha = login_try_count >= 3
    response = render(request, 'sigin.html', {'has_captcha': has_captcha})
    response.set_cookie('login_try_count', login_try_count)
    return response


def logout(request):
    main_logout(request)
    login_try_count = request.COOKIES.get('login_try_count', 0)
    if not str(login_try_count).isdigit():
        login_try_count = 0
    login_try_count = int(login_try_count)
    has_captcha = login_try_count >= 3
    response = render(request, 'sigin.html', {'has_captcha': has_captcha})
    response.set_cookie('login_try_count', login_try_count)
    return response


def try_login(request):
    username = request.POST.get('username', '')
    password = request.POST.get('password', '')
    captcha = request.POST.get('captcha', '')
    hidden_captcha = request.POST.get('hidden_captcha', '')
    login_try_count = request.COOKIES.get('login_try_count', 0)
    if not str(login_try_count).isdigit():
        login_try_count = 0
    login_try_count = int(login_try_count)
    login_try_count += 1
    has_captcha = login_try_count >= 3
    if request.method == 'GET':
        response = render(request, 'sigin.html', {'has_captcha': has_captcha})
        return response
    if (not username) or (not password) or (hidden_captcha and (hidden_captcha != captcha)):
        response = render(request, 'sigin.html', {'has_captcha': has_captcha, 'has_error': True})
        return response
    else:
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            response = render(request, 'sigin.html', {'has_captcha': has_captcha})
            response.set_cookie('login_try_count', 0)
            return response
        response = render(request, 'sigin.html', {'has_captcha': has_captcha})
    response.set_cookie('login_try_count', login_try_count)
    return response
