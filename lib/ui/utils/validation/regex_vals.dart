const createPasswordRegex =
    r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$";

const emailRegex = r"^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$";

const mobileRegex = r"""65[6|8|9]\d{7}$""";

const genderRegex = r"""	
^(?:m|M|f|F)$""";