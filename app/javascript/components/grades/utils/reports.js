import _ from 'lodash/fp';

export const flatAllReports = _.flatMap('reports');

const createReport = (id, tx, hash) => ({
  id,
  tx,
  hash,
});

const findReport = (reports, studentID, courseID) => {
  const reportIndex = _.findIndex({
    student_id: studentID,
    course_id: courseID,
  })(reports);

  if (_.lt(reportIndex, 0)) {
    return createReport(null, null);
  }

  return createReport(
    reports[reportIndex].id,
    reports[reportIndex].transaction_id,
    reports[reportIndex].content_hash,
  );
};

export default findReport;
