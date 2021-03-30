import _ from 'lodash/fp';

const isUndefined = (values) => (
  _.isUndefined(values)
);

const buildNewLine = (student, termName, lessonName, markValue) => ({
  Student: `${student.name} ${student.first_surname} ${student.second_surname}`,
  Term: termName,
  Lesson: lessonName,
  Mark: markValue,
});

const convertToCSV = (courseMembers) => {
  const dataCSV = [];

  _.forEach((courseMember) => {
    const { student } = courseMember;
    if (!isUndefined(courseMember.terms)) {
      _.forEach((term) => {
        const { name: termName } = term.term;
        if (!isUndefined(term.lessons)) {
          _.forEach((lesson) => {
            const { name: lessonName } = lesson.lesson;
            const { value: markValue } = lesson.mark;
            dataCSV.push(buildNewLine(student, termName, lessonName, markValue));
          })(term.lessons);
        }
      })(courseMember.terms);
    }
  })(courseMembers);

  return dataCSV;
};

export default convertToCSV;
