import _ from 'lodash/fp';
import findMark, { flatAllMarks } from './marks';

const REMARKABLE_TYPES = {
  lesson: 'Lesson',
  term: 'Term',
  course: 'Course',
};

const filterLessons = (lessons, ID = null) => _.filter(['term_id', ID])(lessons);

const filterTerms = (terms, selectedTerm) => (
  _.isUndefined(selectedTerm) ? terms : _.filter(['id', selectedTerm.id])(terms)
);

const setCourseLessons = (lessons, marks, studentID) => (
  _.map((lesson) => ({
    lesson,
    mark: findMark(marks, studentID, lesson.id, REMARKABLE_TYPES.lesson),
  }))(lessons)
);

const setCourseTerms = (terms, lessons, marks, studentID) => (
  _.map((term) => ({
    term,
    lessons: setCourseLessons(filterLessons(lessons, term.id), marks, studentID),
    termMark: findMark(marks, studentID, term.id, REMARKABLE_TYPES.term),
  }))(terms)
);

const setMembersWithoutTerms = (course, marks) => (
  _.map((student) => ({
    student,
    lessons: setCourseLessons(course.lessons, marks, student.id),
    courseMark: findMark(marks, student.id, course.id, REMARKABLE_TYPES.course),
  }))(course.students)
);

const setMembersWithTerms = (course, marks, selectedTerm) => (
  _.map((student) => ({
    student,
    terms: setCourseTerms(
      filterTerms(course.terms, selectedTerm), course.lessons, marks, student.id,
    ),
    lessons: setCourseLessons(filterLessons(course.lessons), marks, student.id),
    courseMark: findMark(marks, student.id, course.id, REMARKABLE_TYPES.course),
  }))(course.students)
);

const getCourseMembers = (course, selectedTerm) => {
  const marks = flatAllMarks(course.students);
  if (_.isEmpty(course.terms)) {
    return setMembersWithoutTerms(course, marks);
  }

  return setMembersWithTerms(course, marks, selectedTerm);
};

export default getCourseMembers;
