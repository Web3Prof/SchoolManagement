# SchoolManagement
A beginner level smart contract assignment about managing data for a school.

# Description
The school will have:
- Headmaster <br>
  the headmaster can create classed, approve or remove teachers and students, also delegate his role
- Classes <br>
  each class has a name and will have students and a homeroom teacher
- Teacher <br>
  can be a homeroom teacher, must enroll to become a teacher and wait for headmaster's approval, can be fired by headmaster
- Student <br>
  will be assigned to a class, must enroll to become a student and wait for headmaster's approval, can be expelled by headmaster

Challenge:

- There are subjects in this school and each can be taught by more that 1 teacher, each teacher teaches 1 subject
- Every student will learn all subjects and has scores between 0-100
- Scores can only be give by the corresponding teacher


# Test Cases - Expected Result:
- Student registration - success
- Teacher registration - success
</br>

- Principal create class - success
- Principal approve registration - success
- Principal assign class - success
- Pricipal reject registration - success
- Principal change status - success
- Principal delegate role - success
</br>

- Non-principal create class - failed
- Non-principal approve registration - failed
- Non-principal assign class - failed
- Non-pricipal reject registration - failed
- Non-principal change status - failed
- Non-principal delegate role - failed

<b>Challenge</b>
- Subject's teacher give score - success
- Non-subject's teacher give score - failed
- View student score - success
