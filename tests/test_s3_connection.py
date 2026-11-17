
from unittest.mock import Mock

from src.storage import check_s3_connection as app


def test_s3_connection_success(monkeypatch, capsys):
    # 1. Use a fictional bucket, not our real AWS bucket.
    monkeypatch.setenv("GPM_S3_BUCKET", "test-bucket")

    # 2. Simulate an S3 client and its response.
    fake_s3 = Mock()
    fake_s3.head_object.return_value = {
        "ContentLength": 141,
        "ContentType": "application/json",
    }

    fake_session = Mock()
    fake_session.client.return_value = fake_s3

    # 3. Replace the real AWS session with our fake one.
    monkeypatch.setattr(
        app.boto3,
        "Session",
        Mock(return_value=fake_session),
    )

    # 4. Execute and verify.
    assert app.main() == 0

    fake_s3.head_object.assert_called_once_with(
        Bucket="test-bucket",
        Key="bronze/s3-smoke-test.json",
    )

    assert "RESULT: PASS" in capsys.readouterr().out


def test_missing_bucket(monkeypatch, capsys):
    monkeypatch.delenv("GPM_S3_BUCKET", raising=False)

    assert app.main() == 1

    assert "GPM_S3_BUCKET is not defined" in (
        capsys.readouterr().out
    )


def test_unexpected_metadata(monkeypatch, capsys):
    monkeypatch.setenv("GPM_S3_BUCKET", "test-bucket")

    fake_s3 = Mock()
    fake_s3.head_object.return_value = {
        "ContentLength": 500,
        "ContentType": "application/json",
    }

    fake_session = Mock()
    fake_session.client.return_value = fake_s3

    monkeypatch.setattr(
        app.boto3,
        "Session",
        Mock(return_value=fake_session),
    )

    assert app.main() == 1

    assert "RESULT: FAIL" in capsys.readouterr().out
