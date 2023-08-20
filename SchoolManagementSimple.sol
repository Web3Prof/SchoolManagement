/*
Assignment 2 - School Management

School Management untuk sebuah sekolah

Ada banyak kelas, setiap kelas punya guru wali kelas dan murid

Nama kelasnya adalah nama-nama buah. (ditentukan kepsek) V

Guru dan murid memiliki status active dan inactive karena 
guru bisa berhenti atau dipecat dan murid bisa keluar atau dikeluarkan oleh kepala sekolah. V

Guru dan murid bisa daftar ke sekolah, tapi hanya menjadi active setelah di setujui oleh kepala sekolah.V

Jabatan kepala sekolah hanya bisa didelegasi oleh kepala sekolah saat itu. V



Challenge:
Di sekolah ini tentu ada beberapa pelajaran yang masing-masing bisa diajar oleh banyak guru.
Setiap murid pasti mengikuti semua pelajaran dan memiliki nilai dalam rentang 0-100.
Nilai hanya dapat diberikan oleh guru pada pelajaran yang diajar.


mapping(string => address) classToHomeroomTeachers;
mapping(string => Students[]) classToStudents;
array string Subjects
mapping subjectToTeachers
struct Student punya mapping subjectToScore

Test Case - Expected Result
student registration - success
teacher registration - success

principal create class - success
principal approve registration - success
principal assign class - success
pricipal reject registration - success
principal change status - success
principal delegate role - success

non-principal create class - failed
non-principal approve registration - failed
non-principal assign class - failed
non-pricipal reject registration - failed
non-principal change status - failed
non-principal delegate role - failed

For challenge, teacher registration requires subject field*
subject's teacher give score - success
non-subject's teacher give score - failed

view student score - success

*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract SchoolManagement{
    address public principal;
    string[] public classes;
    address[] public students;
    address[] public teachers;

    struct Class{
        uint256 classId;
        string className;
    }

    struct Student{
        bool isActive;
        address studentAddress;
        string studentName;
        string class;
    }

    struct Teacher{
        bool isActive;
        address teacherAddress;
        string teacherName;
        string class;
    }

    enum Role{
        STUDENT,
        TEACHER
    }
    uint classId;
    mapping (string => Class) public classNameToClass;
    mapping (address => Teacher) public addressToTeacher;
    mapping (address => Student) public addressToStudent;

    event StatusChanged(address _address, bool _isActive);

    constructor(){
        principal = msg.sender;
    }

    function delegatePrincipal(address _newPrincipal) onlyPrincipal external{
        principal = _newPrincipal;
    }

    function register(string calldata _name, Role _role) external{
        require(addressToStudent[msg.sender].studentAddress == address(0x0) 
            && addressToTeacher[msg.sender].teacherAddress == address(0x0), "Already registered.");
        if(_role == Role.STUDENT){
            Student memory newStudent = Student(false, msg.sender, _name, "");
            students.push(msg.sender);
            addressToStudent[msg.sender] = newStudent;
        }
        else if(_role == Role.TEACHER){
            Teacher memory newTeacher = Teacher(false, msg.sender, _name, "");
            teachers.push(msg.sender);
            addressToTeacher[msg.sender] = newTeacher;
        }
    }

    function createClass(string calldata _class) onlyPrincipal external{
        classes.push(_class);
        classId++;
        Class memory newClass = Class(classId, _class);
        classNameToClass[_class] = newClass;
    }

    function changeTeacherStatus(address _teacher) onlyPrincipal external{
        addressToTeacher[_teacher].isActive = !addressToTeacher[_teacher].isActive; // !true = false
        emit StatusChanged(_teacher, addressToTeacher[_teacher].isActive);
    }

    function changeStudentStatus(address _student) onlyPrincipal external{
        addressToStudent[_student].isActive = !addressToStudent[_student].isActive;
        emit StatusChanged(_student, addressToStudent[_student].isActive);
    }

    function assignHomeroom(address _teacher, string memory _class) onlyPrincipal classExist(_class) external{
        require(addressToTeacher[_teacher].isActive, "Teacher is not active.");
        addressToTeacher[_teacher].class = _class;
    }

    function assignStudent(address _student, string memory _class) onlyPrincipal classExist(_class) external{
        require(addressToStudent[_student].isActive, "Student is not active.");
        addressToStudent[_student].class = _class;
    }

    function getAllStudents() external view returns(Student[] memory){
        Student[] memory _students = new Student[](students.length);
        for(uint i = 0; i < students.length; i++){
            _students[i] = addressToStudent[students[i]];
        }
        return _students;
    }

    function getAllTeachers() external view returns(Teacher[] memory){
        Teacher[] memory _teachers = new Teacher[](teachers.length);
        for(uint i = 0; i < teachers.length; i++){
            _teachers[i] = addressToTeacher[teachers[i]];
        }
        return _teachers;
    }
    
    modifier onlyPrincipal{
        require(msg.sender == principal, "Only principal can execute function.");
        _;
    }
    
    modifier classExist(string memory _class) {
        require(classes.length > 0 && classNameToClass[_class].classId != (0x0), "No classes to assign.");
        _;
    }

}