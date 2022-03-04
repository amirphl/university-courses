def q1():
    """
    question 1
    :return:
    """
    from hashlib import md5, sha256
    plaintext = "If you want to keep a secret, you must also hide it from yourself".encode('utf-8')
    my_md5 = md5()
    my_md5.update(plaintext)
    md5_cipher_text = my_md5.hexdigest()
    print('md5 result before deleting character:\n', md5_cipher_text)

    my_sha256 = sha256()
    my_sha256.update(plaintext)
    sha256_cipher_text = my_sha256.hexdigest()
    print('sha256 result before deleting character:\n', sha256_cipher_text)

    plaintext = "f you want to keep a secret, you must also hide it from yourself".encode('utf-8')
    my_md5 = md5()
    my_md5.update(plaintext)
    md5_cipher_text = my_md5.hexdigest()
    print('md5 result after deleting character:\n', md5_cipher_text)

    my_sha256 = sha256()
    my_sha256.update(plaintext)
    sha256_cipher_text = my_sha256.hexdigest()
    print('sha256 result after deleting character:\n', sha256_cipher_text)


def q2():
    from cryptography.fernet import Fernet
    key = Fernet.generate_key()
    cipher_suite = Fernet(key)
    cipher_text = cipher_suite.encrypt(b"9531014")
    print('cipher_text of 9531014:\n', cipher_text)
    plain_text = cipher_suite.decrypt(cipher_text)
    print('decrypted cipher text', plain_text)


print('----------')
print('question 1')
print('----------')
q1()
print('----------')
print('question 2')
print('----------')
q2()
print('----------')
print('question 3')
print('----------')
