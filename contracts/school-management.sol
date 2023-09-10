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
        bool isActive; // 0
        address studentAddress; // 1
        string studentName; // 2
        uint256 classId;
    }

    struct Teacher{
        bool isActive;
        address teacherAddress;
        string teacherName;
        uint256 classId;
    }

    enum Role{
        STUDENT,
        TEACHER
    }
    uint classId;
    mapping (uint256 => Class) public classIdToClass;
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
            Student memory newStudent = Student(false, msg.sender, _name, 0);
            students.push(msg.sender);
            addressToStudent[msg.sender] = newStudent;
        }
        else if(_role == Role.TEACHER){
            Teacher memory newTeacher = Teacher(false, msg.sender, _name, 0);
            teachers.push(msg.sender);
            addressToTeacher[msg.sender] = newTeacher;
        }
    }

    function createClass(string calldata _class) onlyPrincipal external{
        classes.push(_class);
        classId++;
        Class memory newClass = Class(classId, _class);
        classIdToClass[classId] = newClass;
    }

    function changeTeacherStatus(address _teacher) onlyPrincipal external{
        addressToTeacher[_teacher].isActive = !addressToTeacher[_teacher].isActive; // !true = false
        emit StatusChanged(_teacher, addressToTeacher[_teacher].isActive);
    }

    function changeStudentStatus(address _student) onlyPrincipal external{
        addressToStudent[_student].isActive = !addressToStudent[_student].isActive;
        emit StatusChanged(_student, addressToStudent[_student].isActive);
    }

    function assignHomeroom(address _teacher, uint256 _classId) onlyPrincipal classExist(_classId) external{
        require(addressToTeacher[_teacher].isActive, "Teacher is not active.");
        addressToTeacher[_teacher].classId = _classId;
    }

    function assignStudent(address _student, uint256 _classId) onlyPrincipal classExist(_classId) external{
        require(addressToStudent[_student].isActive, "Student is not active.");
        addressToStudent[_student].classId = _classId;
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
    
    modifier classExist(uint256 _classId) {
        require(classes.length > 0 && classIdToClass[_classId].classId != 0, "No classes to assign.");
        _;
    }

}