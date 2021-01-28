import _ from 'lodash/fp';

const remarkable_types = {
  lesson: 'lesson',
  term: 'term',
  course: 'course'
};

const createMark = (value, student_id, remarkable_type, remarkable_id ) => (
  {
    value: value,
    student_id: student_id,
    remarkable_type: remarkable_type,
    remarkable_id: remarkable_id
  }
);

const findMark = (marks, student_id, remarkable_type, remarkable_id) => {
  const currentMark = _.map((mark) => {
    if( _.isEqual(mark.student_id, student_id) 
      && _.isEqual(mark.remarkable_type, remarkable_type)
      && _.isEqual(mark.remarkable_id, remarkable_id) ) {
        return mark;
      }
  })(marks)

  if(_.isEmpty(currentMark)) {
    return createMark(null, student_id, remarkable_type, remarkable_id);
  }

  return createMark(
      currentMark.value, 
      currentMark.student_id, 
      currentMark.remarkable_type, 
      currentMark.remarkable_id
    )
};

const flatAllMarks = _.flow(
  _.flatMap('marks')
);

const setLessons = (lessons, marks, student_id, course_id) => (
  _.map((lesson) => {
    return {
      lesson: lesson,
      mark: findMark(marks, student_id, remarkable_types.lesson, course_id)
    }
  })(lessons)
);

const setTerms = (terms, lessons, marks, student_id, course_id) => (
  _.map((term) => {
    return {
      term: term,
      lessons: setLessons(_.filter(['term_id', term.id])(lessons), marks, student_id, course_id),
      termMark: findMark(marks, student_id, remarkable_types.term, term.id),
    }
  })(terms)
);

const studentsWithoutTerms = (course, marks) => (
  _.map((student) => {
    return {
      student: student,
      lessons: setLessons(course.lessons, marks, student.id, course.id),
      courseMark: findMark(marks, student.id, remarkable_types.course, course.id),
    }
  })(course.students)
);

const studentsWithTerms = (course, marks, selectedTerm) => (
  _.map((student) => {
    const terms = (
      _.isUndefined(selectedTerm) ? course.terms : _.filter(['id', selectedTerm.id])(course.terms)
    );
    return {
      student: student,
      terms: setTerms(terms, course.lessons, marks, student.id, course.id),
      courseMark: findMark(marks, student.id, remarkable_types.course, course.id),
    }
  })(course.students)
);


const setCourseStudents = (course, selectedTerm) => {
  const marks = flatAllMarks(course.students);
  if(_.isEmpty(course.terms)){
    return studentsWithoutTerms(course, marks); 
  }
  return studentsWithTerms(course, marks, selectedTerm);
}

export default setCourseStudents;
