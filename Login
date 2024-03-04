#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h> // isdigit function usage.
#include <stdbool.h> // Used for bool.

// Maximum characters and numbers a user can use when trying to open an account
#define MAX_USERNAME_LENGTH 50
#define MAX_PASSWORD_LENGTH 50
#define MAX_USERS 100
#define MAX_ADDRESS_LENGTH 100
#define MAX_PHONE_LENGTH 11 
#define MAX_EMAIL_LENGTH 50
// User class
struct User {
    char username[MAX_USERNAME_LENGTH];
    char password[MAX_PASSWORD_LENGTH];
    char address[MAX_ADDRESS_LENGTH];
    char phone[MAX_PHONE_LENGTH];
    char email[MAX_EMAIL_LENGTH];
    int age;
    char gender;
};
// Function to save user information to a file
void saveUser(const struct User *user) {
    FILE *file = fopen("user_info.txt", "a");
    if (file == NULL) {
        printf("File could not be opened!");
        return;
    }

    fprintf(file, "%s %s %s %s %s %d %c\n", user->username, user->password, user->address, user->phone, user->email, user->age, user->gender);

    fclose(file);
}
// Function to print all users information from the file
void printUsers() {
    FILE *file = fopen("user_info.txt", "r");
    if (file == NULL) {
        printf("File could not be opened!");
        return;
    }
// where the users will be stored
    struct User user; 
    while (fscanf(file, "%s %s %s %s %s %d %c", user.username, user.password, user.address, user.phone, user.email, &user.age, &user.gender) != EOF) {
        printf("Username: %s\n", user.username);
        printf("Address: %s\n", user.address);
        printf("Phone: %s\n", user.phone);
        printf("E-mail: %s\n", user.email);
        printf("Age: %d\n", user.age);
        printf("Gender: %c\n", user.gender);
        printf("\n");
    }

    fclose(file);
}
// Function to allow a user to log in
void loginUser(struct User *user) {
    printf("Username: ");
    scanf("%s", user->username);
    printf("Password: ");
    scanf("%s", user->password);
}
// Function to check if an email address is valid
bool isEmailValid(const char *email) {
    int i = 0;
    while (email[i] != '\0') {
        if (email[i] == '@') {
            return true;
        }
        i++;
    }
    return false;
}
// Function to check if a user already exists
bool userExists(const struct User *user) {
    FILE *file = fopen("user_info.txt", "r");
    if (file == NULL) {
        printf("File could not be opened!");
        return false;
    }

    struct User tempUser;
    while (fscanf(file, "%s %s %s %s %s %d %c", tempUser.username, tempUser.password, tempUser.address, tempUser.phone, tempUser.email, &tempUser.age, &tempUser.gender) != EOF) {
        if (strcmp(tempUser.username, user->username) == 0 || (strcmp(tempUser.phone, user->phone) == 0 && strcmp(tempUser.email, user->email) == 0)) {
            fclose(file);
            return true;
        }
    }

    fclose(file);
    return false;
}
// Function to register a new user
void registerUser() {
    struct User user;
    printf("Username: ");
    scanf("%s", user.username);
    do {
        printf("Password (at least 8 characters): ");
        scanf("%s", user.password);
        if (strlen(user.password) < 8) { // Checks if 8 characters were entered.
            printf("Password must be at least 8 characters long.\n");
        }
    } while (strlen(user.password) < 8);
    printf("Address (City district apartment floor door number building number): ");
    scanf(" %[^\n]s", user.address); // The use of these symbols is to prevent issues with spaces.
    do {
        printf("Phone (Enter only 10 digits): ");
        scanf("%s", user.phone);
        int phoneDigits = 0;
        int i = 0;
        while (user.phone[i] != '\0') {
            if (isdigit(user.phone[i])) {
                phoneDigits++;
            }
            i++;
        }
        if (phoneDigits != 10) {
            printf("Phone number must be 10 digits.\n");
        }
    } while (strlen(user.phone) != 10); // Checks if there are 10 digits in the phone number.
    printf("E-mail: ");
    scanf("%s", user.email);
    while (!isEmailValid(user.email)) {
        printf("Invalid e-mail address. Please re-enter: ");
        scanf("%s", user.email);
    }
    printf("Age: ");
    while (scanf("%d", &user.age) != 1) {
        printf("Please enter digits only: ");
        while (getchar() != '\n');
        printf("Age: ");
    }
    printf("Gender (M: Male, F: Female, N: Prefer not to say): ");
    scanf(" %c", &user.gender);
    while (user.gender != 'm' && user.gender != 'f' && user.gender != 'n' && // Now includes lowercase letters.
       user.gender != 'M' && user.gender != 'F' && user.gender != 'N') {
    printf("Invalid gender. Please re-enter (M: Male, F: Female, N: Prefer not to say): ");
    scanf(" %c", &user.gender);
    }

    if (userExists(&user)) {
        printf("This user is already registered!\n");
    } else {
        saveUser(&user);
        printf("Registration successful.\n");
    }
}
// Function to check user credentials during login
int checkCredentials(const struct User *user) {
    FILE *file = fopen("user_info.txt", "r");
    if (file == NULL) {
        printf("File could not be opened!");
        return 0;
    }

    struct User tempUser;
    while (fscanf(file, "%s %s %s %s %s %d %c", tempUser.username, tempUser.password, tempUser.address, tempUser.phone, tempUser.email, &tempUser.age, &tempUser.gender) != EOF) { // EOF End of the file.
        if (strcmp(tempUser.username, user->username) == 0 && strcmp(tempUser.password, user->password) == 0) {
            fclose(file);
            return 1;
        }
    }

    fclose(file);
    return 0;
}

int main() {
    int choice;
    do {
        printf("1. Register\n");
        printf("2. Login\n");
        printf("3. Display All Users\n");
        printf("4. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);

        struct User currentUser;

        switch (choice) {
            case 1:
                registerUser();
                break;
            case 2:
                loginUser(&currentUser);
                if (checkCredentials(&currentUser)) {
                    printf("Login successful!\n");
                } else {
                    printf("Login failed. Incorrect username or password.\n");
                }
                break;
            case 3:
                printUsers();
                break;
            case 4:
                printf("Exiting...\n");
                break;
            default:
                printf("Invalid choice. Please enter a number between 1 and 4.\n");
        }
    } while (choice != 4);

    return 0;
}
