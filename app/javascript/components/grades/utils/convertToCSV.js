// import _ from 'lodash/fp';
// TODO - refactor with lodash
export default function convertToCSV(courseMembers) {
  const dataCSV = [];

  courseMembers.forEach((courseMember) => {
    const { student } = courseMember;
    if (courseMember.terms !== undefined) {
      courseMember.terms.forEach((term) => {
        if (term.lessons !== undefined) {
          term.lessons.forEach((lesson) => {
            const newLine = {
              Student: `${student.name} ${student.first_surname} ${student.second_surname}`,
              Term: term.term.name,
              Lesson: lesson.lesson.name,
              Mark: lesson.mark.value,
            };

            dataCSV.push(newLine);
          });
        }
      });
    }
  });

  return dataCSV;
}

/* const setNewLine = (student, term, lesson) => ({
  Student: `${student.name} ${student.first_surname} ${student.second_surname}`,
  Term: term.term.name,
  Lesson: lesson.lesson.name,
  Mark: lesson.mark.value,
});

const setLessons = (student, term) => (
  !_.isUndefined(term.lessons)
  ? _.map((lesson) => setNewLine(student, term, lesson))(term.lessons)
  : null
);

const setTerms = (courseMember) => (
  !_.isUndefined(courseMember.terms)
  ? _.map((term) => setLessons(courseMember.student, term))(courseMember.terms)
  : null
);

const convertToCSV = _.flow(
  _.map((courseMember) => setTerms(courseMember)),
  _.compact,
);

export default convertToCSV; */
